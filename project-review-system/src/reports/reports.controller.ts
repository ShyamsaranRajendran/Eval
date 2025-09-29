import { Controller, Get, Post, Param, Query, Body, UseGuards, Response } from '@nestjs/common';
import { ReportsService } from './reports.service';
import type { 
  PanelSummaryReport, 
  StudentTranscriptReport, 
  FacultyWorkloadReport, 
  DashboardStats 
} from './reports.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { UserRole } from '../users/schemas/user.schema';

@Controller('reports')
@UseGuards(JwtAuthGuard, RolesGuard)
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get('panel-summary/:panelId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR, UserRole.FACULTY)
  async getPanelSummaryReport(@Param('panelId') panelId: string): Promise<PanelSummaryReport> {
    return this.reportsService.generatePanelSummaryReport(panelId);
  }

  @Get('student-transcript/:studentId')
  async getStudentTranscript(@Param('studentId') studentId: string): Promise<StudentTranscriptReport> {
    return this.reportsService.generateStudentTranscript(studentId);
  }

  @Get('faculty-workload/:facultyId/:reviewPhaseId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getFacultyWorkloadReport(
    @Param('facultyId') facultyId: string,
    @Param('reviewPhaseId') reviewPhaseId: string,
  ): Promise<FacultyWorkloadReport> {
    return this.reportsService.generateFacultyWorkloadReport(facultyId, reviewPhaseId);
  }

  @Get('dashboard-stats')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getDashboardStats(@Query('reviewPhaseId') reviewPhaseId?: string): Promise<DashboardStats> {
    return this.reportsService.getDashboardStats(reviewPhaseId);
  }

  @Get('performance-analytics/:reviewPhaseId')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async getPerformanceAnalytics(@Param('reviewPhaseId') reviewPhaseId: string): Promise<{
    scoreDistribution: Array<{
      range: string;
      count: number;
      percentage: number;
    }>;
    topPerformers: Array<{
      studentId: string;
      name: string;
      registerNo: string;
      totalScore: number;
      percentage: number;
    }>;
    criteriaAnalysis: Array<{
      criteriaName: string;
      averageScore: number;
      maxScore: number;
      standardDeviation: number;
    }>;
    panelComparison: Array<{
      panelName: string;
      averageScore: number;
      studentCount: number;
    }>;
  }> {
    return this.reportsService.getPerformanceAnalytics(reviewPhaseId);
  }

  @Post('export/csv')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async exportToCSV(
    @Body() body: { reportType: string; data: any },
    @Response() res: any,
  ): Promise<void> {
    const csv = await this.reportsService.exportToCSV(body.reportType, body.data);
    res.header('Content-Type', 'text/csv');
    res.header('Content-Disposition', `attachment; filename="${body.reportType}.csv"`);
    res.send(csv);
  }

  @Post('export/pdf')
  @Roles(UserRole.ADMIN, UserRole.COORDINATOR)
  async generatePDF(
    @Body() body: { reportType: string; data: any },
    @Response() res: any,
  ): Promise<void> {
    const pdfBuffer = await this.reportsService.generatePDF(body.reportType, body.data);
    res.header('Content-Type', 'application/pdf');
    res.header('Content-Disposition', `attachment; filename="${body.reportType}.pdf"`);
    res.send(pdfBuffer);
  }
}
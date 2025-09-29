# Project Review System

A comprehensive NestJS-based system for managing project reviews, evaluations, and final reports in academic environments.

## Features

- **User Management**: Support for multiple user roles (Admin, Reviewer, Supervisor, Student)
- **Project Management**: Full project lifecycle management with student assignments
- **Batch Management**: Organize projects by academic batches
- **Panel Management**: Create review panels with coordinators
- **Review System**: Multi-stage review process with weighted scoring
- **Final Report Generation**: Automated report generation with comprehensive analytics

## Architecture

The application follows a modular NestJS architecture with the following modules:

- **User Module**: User authentication and role management
- **Project Module**: Project creation and management
- **Batch Module**: Academic batch organization
- **Panel Module**: Review panel coordination
- **Review Module**: Review scoring and comments
- **Final Report Module**: Automated report generation

## Prerequisites

- Node.js (v16 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn package manager

## Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd project-review-system
```

2. **Install dependencies**

```bash
npm install
```

3. **Set up MongoDB**

   Make sure MongoDB is running on your system. The default connection string is:

   ```
   mongodb://localhost:27017/project_review_system
   ```

   You can modify the connection string in `src/app.module.ts` if needed.

4. **Environment Setup**

   Create a `.env` file in the root directory with:

   ```env
   MONGODB_URI=mongodb://localhost:27017/project_review_system
   PORT=3000
   ```

## Running the Application

```bash
# Development mode with hot reload
npm run start:dev

# Production mode
npm run start:prod

# Debug mode
npm run start:debug
```

The application will be available at `http://localhost:3000`

## API Endpoints

### Users (`/users`)

- `POST /users` - Create a new user
- `GET /users` - Get all users
- `GET /users/:id` - Get user by ID
- `GET /users/role/:role` - Get users by role
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Delete user

### Projects (`/projects`)

- `POST /projects` - Create a new project
- `GET /projects` - Get all projects
- `GET /projects/:id` - Get project details with populated references
- `GET /projects/batch/:batchId` - Get projects by batch
- `GET /projects/supervisor/:supervisorId` - Get projects by supervisor
- `PUT /projects/:id/students` - Add student to project
- `PUT /projects/:id/reviewers` - Assign reviewers to project
- `PUT /projects/:id` - Update project
- `DELETE /projects/:id` - Delete project

### Batches (`/batches`)

- `POST /batches` - Create a new batch
- `GET /batches` - Get all batches
- `GET /batches/:id` - Get batch by ID
- `GET /batches/department/:department` - Get batches by department
- `GET /batches/year/:year` - Get batches by year
- `PUT /batches/:id` - Update batch
- `DELETE /batches/:id` - Delete batch

### Panels (`/panels`)

- `POST /panels` - Create a new panel
- `GET /panels` - Get all panels
- `GET /panels/:id` - Get panel with details
- `GET /panels/coordinator/:coordinatorId` - Get panels by coordinator
- `PUT /panels/:id/projects` - Assign project to panel
- `DELETE /panels/:id/projects/:projectId` - Remove project from panel
- `PUT /panels/:id` - Update panel
- `DELETE /panels/:id` - Delete panel

### Reviews (`/reviews`)

- `POST /reviews` - Create a new review
- `GET /reviews` - Get all reviews
- `GET /reviews/:id` - Get review by ID
- `GET /reviews/project/:projectId` - Get reviews for a project
- `GET /reviews/project/:projectId/review/:reviewNumber` - Get specific review
- `PUT /reviews/:id/marks` - Add marks to review
- `PUT /reviews/:id/comments` - Add comment to review
- `GET /reviews/:id/total-score` - Calculate total score
- `PUT /reviews/:id` - Update review
- `DELETE /reviews/:id` - Delete review

### Final Reports (`/final-reports`)

- `POST /final-reports/generate/:projectId` - Generate final report for project
- `GET /final-reports` - Get all final reports
- `GET /final-reports/:id` - Get final report by ID
- `GET /final-reports/project/:projectId` - Get final report for project
- `PUT /final-reports/:id` - Update final report
- `DELETE /final-reports/:id` - Delete final report

## Data Models

### User Schema

```typescript
{
  name: string;
  email: string; // unique
  role: 'Admin' | 'Reviewer' | 'Supervisor' | 'Student';
  passwordHash: string;
  createdAt: Date;
}
```

### Project Schema

```typescript
{
  batchId: ObjectId; // Reference to Batch
  projectTitle: string;
  supervisorId: ObjectId; // Reference to User
  students: [{
    studentName: string;
    registerNo: string; // unique
  }];
  reviewers: ObjectId[]; // References to Users
  createdAt: Date;
}
```

### Review Schema

```typescript
{
  projectId: ObjectId; // Reference to Project
  reviewNumber: number; // 1 = Review I, 2 = Review II, etc.
  maxTotal: number; // default: 100
  weight: number; // e.g., 0.3, 0.4
  reviewDate: Date;
  criteria: [{
    criteriaName: string;
    maxMarks: number;
  }];
  marks: [{
    studentId: ObjectId;
    reviewerId: ObjectId;
    criteriaName: string;
    marksObtained: number;
  }];
  comments: [{
    reviewerId: ObjectId;
    comment: string;
  }];
}
```

## Development

### Project Structure

```
src/
├── user/
│   ├── schemas/
│   │   └── user.schema.ts
│   ├── user.controller.ts
│   ├── user.service.ts
│   └── user.module.ts
├── project/
│   ├── schemas/
│   │   └── project.schema.ts
│   ├── project.controller.ts
│   ├── project.service.ts
│   └── project.module.ts
├── batch/
├── panel/
├── review/
├── final-report/
├── app.module.ts
└── main.ts
```

### Running Tests

```bash
# Unit tests
npm run test

# e2e tests
npm run test:e2e

# Test coverage
npm run test:cov
```

### Building for Production

```bash
npm run build
```

## Troubleshooting

### MongoDB Connection Issues

1. Ensure MongoDB is running: `mongod`
2. Check if the database exists and is accessible
3. Verify the connection string in `app.module.ts`

### Port Already in Use

If port 3000 is already in use, modify the port in `src/main.ts` or set the `PORT` environment variable.

## License

This project is [MIT licensed](LICENSE).

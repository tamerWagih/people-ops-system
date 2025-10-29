import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Employee } from '../entities/employee.entity';
import { EmployeeService } from './employee.service';
import { EmployeeController } from './employee.controller';
import { AuditLogService } from '../auth/audit-log.service';
import { AuditLog } from '../entities/audit-log.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Employee, AuditLog])],
  controllers: [EmployeeController],
  providers: [EmployeeService, AuditLogService],
  exports: [EmployeeService],
})
export class EmployeeModule {}



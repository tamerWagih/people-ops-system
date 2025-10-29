import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog } from '../entities/audit-log.entity';

export interface AuditLogData {
  tableName: string;
  recordId: string;
  action: 'INSERT' | 'UPDATE' | 'DELETE';
  oldValues?: Record<string, unknown>;
  newValues?: Record<string, unknown>;
  changedBy?: string;
  ipAddress?: string;
  userAgent?: string;
}

@Injectable()
export class AuditLogService {
  constructor(
    @InjectRepository(AuditLog)
    private readonly auditLogRepository: Repository<AuditLog>,
  ) {}

  /**
   * Create audit log entry
   */
  async log(
    data: AuditLogData,
  ): Promise<AuditLog> {
    const auditLog = this.auditLogRepository.create({
      tableName: data.tableName,
      recordId: data.recordId,
      action: data.action,
      oldValues: data.oldValues || undefined,
      newValues: data.newValues || undefined,
      changedBy: data.changedBy || undefined,
      ipAddress: data.ipAddress || undefined,
      userAgent: data.userAgent || undefined,
    });

    return this.auditLogRepository.save(auditLog);
  }

  /**
   * Get audit logs for a specific record
   */
  async getRecordAuditLogs(
    tableName: string,
    recordId: string,
    limit: number = 50,
  ): Promise<AuditLog[]> {
    return this.auditLogRepository.find({
      where: { tableName, recordId },
      order: { changedAt: 'DESC' },
      take: limit,
    });
  }

  /**
   * Get audit logs for a table
   */
  async getTableAuditLogs(
    tableName: string,
    limit: number = 100,
  ): Promise<AuditLog[]> {
    return this.auditLogRepository.find({
      where: { tableName },
      order: { changedAt: 'DESC' },
      take: limit,
    });
  }

  /**
   * Get audit logs for a user
   */
  async getUserAuditLogs(
    changedBy: string,
    limit: number = 100,
  ): Promise<AuditLog[]> {
    return this.auditLogRepository.find({
      where: { changedBy },
      order: { changedAt: 'DESC' },
      take: limit,
    });
  }
}

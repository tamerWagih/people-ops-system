import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('audit_logs')
export class AuditLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 100, name: 'table_name' })
  tableName: string;

  @Column({ type: 'uuid', name: 'record_id' })
  recordId: string;

  @Column({
    type: 'varchar',
    length: 20,
  })
  action: 'INSERT' | 'UPDATE' | 'DELETE';

  @Column({ type: 'jsonb', nullable: true, name: 'old_values' })
  oldValues?: Record<string, unknown>;

  @Column({ type: 'jsonb', nullable: true, name: 'new_values' })
  newValues?: Record<string, unknown>;

  @Column({ type: 'uuid', nullable: true, name: 'changed_by' })
  changedBy?: string;

  @Column({ type: 'inet', nullable: true, name: 'ip_address' })
  ipAddress?: string;

  @Column({ type: 'text', nullable: true, name: 'user_agent' })
  userAgent?: string;

  @CreateDateColumn({ type: 'timestamptz', name: 'changed_at' })
  changedAt: Date;

  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'changed_by' })
  changedByUser?: User;
}

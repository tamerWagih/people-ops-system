import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('login_logs')
export class LoginLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'uuid', nullable: true, name: 'user_id' })
  userId?: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  username?: string;

  @Column({ type: 'inet', nullable: true, name: 'ip_address' })
  ipAddress?: string;

  @Column({ type: 'text', nullable: true, name: 'user_agent' })
  userAgent?: string;

  @Column({ type: 'boolean', name: 'login_successful' })
  loginSuccessful: boolean;

  @Column({ type: 'varchar', length: 100, nullable: true, name: 'failure_reason' })
  failureReason?: string;

  @CreateDateColumn({ type: 'timestamptz', name: 'login_time' })
  loginTime: Date;

  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'user_id' })
  user?: User;
}

import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  OneToMany,
} from 'typeorm';
import { RolePermission } from './role-permission.entity';

@Entity('permissions')
export class Permission {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  name: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column()
  module: string; // HR, WFM, ADMIN, etc.

  @Column()
  action: string; // CREATE, READ, UPDATE, DELETE

  @Column()
  resource: string; // EMPLOYEE, SCHEDULE, etc.

  @CreateDateColumn()
  createdAt: Date;

  // Relations
  @OneToMany(() => RolePermission, (rolePermission) => rolePermission.permission)
  rolePermissions: RolePermission[];
}

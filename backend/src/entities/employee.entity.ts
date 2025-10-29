import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('employees')
export class Employee {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index('idx_employees_employeeId', { unique: true })
  @Column({ length: 32, unique: true })
  employeeId: string; // internal employee code

  @Column({ length: 100 })
  firstName: string;

  @Column({ length: 100 })
  lastName: string;

  @Index('idx_employees_nationalId', { unique: true })
  @Column({ length: 32, unique: true })
  nationalId: string;

  @Index('idx_employees_department')
  @Column({ length: 100 })
  department: string;

  @Index('idx_employees_position')
  @Column({ length: 100 })
  position: string;

  @Index('idx_employees_email', { unique: true })
  @Column({ length: 150, unique: true })
  email: string;

  @Column({ length: 30, nullable: true })
  phone?: string;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}



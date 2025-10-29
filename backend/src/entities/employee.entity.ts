import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  Generated,
} from 'typeorm';

@Entity('employees')
export class Employee {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index('idx_employees_hr_id', { unique: true })
  @Generated('increment')
  @Column({ name: 'hr_id', type: 'int', unique: true, nullable: true })
  employeeId?: number; // Maps to hr_id in database - auto-incrementing

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @Column({ name: 'created_by', nullable: true })
  createdBy?: string;

  @Column({ name: 'updated_by', nullable: true })
  updatedBy?: string;

  // Basic Personal Information
  @Column({ name: 'full_name_en', length: 255 })
  firstName: string; // Maps to full_name_en

  @Column({ name: 'full_name_ar', length: 255, nullable: true })
  lastName?: string; // Maps to full_name_ar

  @Index('idx_employees_national_id', { unique: true })
  @Column({ name: 'national_id', length: 20, unique: true })
  nationalId: string;

  @Column({ name: 'national_id_expiry', type: 'date', nullable: true })
  nationalIdExpiry?: Date;

  @Column({ name: 'date_of_birth', type: 'date', nullable: true })
  dateOfBirth?: Date;

  @Column({ 
    name: 'gender', 
    length: 10, 
    nullable: true,
    enum: ['Male', 'Female']
  })
  gender?: 'Male' | 'Female';

  @Column({ name: 'religion', length: 50, nullable: true })
  religion?: string;

  @Column({ name: 'nationality', length: 50, default: 'Egyptian' })
  nationality: string;

  @Column({ name: 'is_egyptian', default: true })
  isEgyptian: boolean;

  @Column({ name: 'passport_number', length: 50, nullable: true })
  passportNumber?: string;

  @Column({ name: 'passport_expiry', type: 'date', nullable: true })
  passportExpiry?: Date;

  // Basic Employment Info
  @Column({ name: 'department_id', nullable: true })
  department?: string;

  @Index('idx_employees_position')
  @Column({ name: 'current_title', length: 100, nullable: true })
  position?: string; // Maps to current_title

  @Index('idx_employees_hire_date')
  @Column({ name: 'hiring_date', type: 'date' })
  hireDate: Date; // Maps to hiring_date

  @Index('idx_employees_status')
  @Column({ 
    name: 'status', 
    length: 20, 
    default: 'Active',
    enum: ['Active', 'Inactive']
  })
  status: 'Active' | 'Inactive';

  @Column({ 
    name: 'employment_type', 
    length: 20, 
    nullable: true,
    enum: ['Full Time', 'Part Time']
  })
  employmentType?: 'Full Time' | 'Part Time';

  // Audit fields
  @Column({ name: 'is_deleted', default: false })
  isDeleted: boolean;

  @Column({ name: 'deleted_at', nullable: true })
  deletedAt?: Date;

  @Column({ name: 'deleted_by', nullable: true })
  deletedBy?: string;

  // Virtual properties for API compatibility
  get fullName(): string {
    return this.firstName + (this.lastName ? ` ${this.lastName}` : '');
  }

  get email(): string {
    // Since email is not in the main employees table, we'll need to get it from employee_contact_info
    // For now, return a placeholder or handle this in the service
    return '';
  }

  set email(value: string) {
    // This will be handled in the service layer
  }
}
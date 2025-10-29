import { IsString, IsEmail, IsOptional, IsDateString, IsEnum, IsBoolean, Length } from 'class-validator';

export class CreateEmployeeDto {
  @IsString()
  @Length(1, 50)
  employeeId: string; // hr_id

  @IsString()
  @Length(1, 255)
  firstName: string; // full_name_en

  @IsString()
  @IsOptional()
  @Length(1, 255)
  lastName?: string; // full_name_ar

  @IsString()
  @Length(1, 20)
  nationalId: string;

  @IsDateString()
  @IsOptional()
  nationalIdExpiry?: string;

  @IsDateString()
  @IsOptional()
  dateOfBirth?: string;

  @IsEnum(['Male', 'Female'])
  @IsOptional()
  gender?: 'Male' | 'Female';

  @IsString()
  @IsOptional()
  @Length(1, 50)
  religion?: string;

  @IsString()
  @IsOptional()
  @Length(1, 50)
  nationality?: string;

  @IsBoolean()
  @IsOptional()
  isEgyptian?: boolean;

  @IsString()
  @IsOptional()
  @Length(1, 50)
  passportNumber?: string;

  @IsDateString()
  @IsOptional()
  passportExpiry?: string;

  @IsString()
  @IsOptional()
  department?: string; // department_id

  @IsString()
  @IsOptional()
  @Length(1, 100)
  position?: string; // current_title

  @IsDateString()
  hireDate: string; // hiring_date

  @IsEnum(['Active', 'Inactive'])
  @IsOptional()
  status?: 'Active' | 'Inactive';

  @IsEnum(['Full Time', 'Part Time'])
  @IsOptional()
  employmentType?: 'Full Time' | 'Part Time';
}
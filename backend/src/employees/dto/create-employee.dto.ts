import { IsBoolean, IsEmail, IsNotEmpty, IsOptional, IsString, Length, Matches, MaxLength } from 'class-validator';

export class CreateEmployeeDto {
  @IsString()
  @Length(1, 32)
  employeeId: string;

  @IsString()
  @Length(1, 100)
  firstName: string;

  @IsString()
  @Length(1, 100)
  lastName: string;

  @IsString()
  @Length(6, 32)
  nationalId: string;

  @IsString()
  @Length(1, 100)
  department: string;

  @IsString()
  @Length(1, 100)
  position: string;

  @IsEmail()
  @MaxLength(150)
  email: string;

  @IsOptional()
  @IsString()
  @MaxLength(30)
  phone?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}



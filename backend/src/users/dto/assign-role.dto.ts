import { IsArray, IsUUID } from 'class-validator';

export class AssignRoleDto {
  @IsArray()
  @IsUUID('4', { each: true })
  roleIds: string[];
}

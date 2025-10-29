import { SetMetadata } from '@nestjs/common';

export const FIELD_PERMISSIONS_KEY = 'fieldPermissions';

export interface FieldPermission {
  field: string;
  permissions: string[];
}

export const FieldPermissions = (...permissions: FieldPermission[]) => 
  SetMetadata(FIELD_PERMISSIONS_KEY, permissions);

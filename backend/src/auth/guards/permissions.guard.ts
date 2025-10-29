import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PERMISSIONS_KEY } from '../decorators/permissions.decorator';

@Injectable()
export class PermissionsGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
  ) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredPermissions = this.reflector.getAllAndOverride<string[]>(PERMISSIONS_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredPermissions || requiredPermissions.length === 0) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest();
    
    if (!user || !user.permissions) {
      throw new ForbiddenException('User permissions not found');
    }

    const hasPermission = requiredPermissions.some((permission) => 
      user.permissions.includes(permission)
    );
    
    if (!hasPermission) {
      throw new ForbiddenException(`Required permission: ${requiredPermissions.join(' or ')}`);
    }

    return true;
  }
}

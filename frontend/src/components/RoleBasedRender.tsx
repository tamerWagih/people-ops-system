'use client';

import React, { ReactNode } from 'react';
import { useAuth } from '../contexts/AuthContext';

interface RoleBasedRenderProps {
  children: ReactNode;
  allowedRoles: string[];
  fallback?: ReactNode;
  requireAll?: boolean; // If true, user must have ALL roles; if false, user needs ANY role
}

const RoleBasedRender: React.FC<RoleBasedRenderProps> = ({
  children,
  allowedRoles,
  fallback = null,
  requireAll = false,
}) => {
  const { user } = useAuth();

  if (!user || !user.roles) {
    return <>{fallback}</>;
  }

  const userRoles = user.roles;
  const hasPermission = requireAll
    ? allowedRoles.every(role => userRoles.includes(role))
    : allowedRoles.some(role => userRoles.includes(role));

  return hasPermission ? <>{children}</> : <>{fallback}</>;
};

export default RoleBasedRender;

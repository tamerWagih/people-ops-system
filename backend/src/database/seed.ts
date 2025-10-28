import { DataSource } from 'typeorm';
import { User } from '../entities/user.entity';
import { Role } from '../entities/role.entity';
import { Permission } from '../entities/permission.entity';
import { UserRole } from '../entities/user-role.entity';
import { RolePermission } from '../entities/role-permission.entity';
import * as bcrypt from 'bcrypt';

export async function seedDatabase(dataSource: DataSource) {
  console.log('🌱 Starting database seeding...');

  const userRepository = dataSource.getRepository(User);
  const roleRepository = dataSource.getRepository(Role);
  const permissionRepository = dataSource.getRepository(Permission);
  const userRoleRepository = dataSource.getRepository(UserRole);
  const rolePermissionRepository = dataSource.getRepository(RolePermission);

  // Create roles
  const roles = [
    {
      name: 'System_Admin',
      description: 'Super Administrator with full system access',
      isSystemRole: true,
    },
    {
      name: 'HR_Manager',
      description: 'Human Resources Manager',
      isSystemRole: false,
    },
    {
      name: 'HR_Specialist',
      description: 'Human Resources Specialist',
      isSystemRole: false,
    },
    {
      name: 'WFM_Manager',
      description: 'Workforce Management Manager',
      isSystemRole: false,
    },
    {
      name: 'WFM_Planner',
      description: 'Workforce Management Planner',
      isSystemRole: false,
    },
    {
      name: 'Employee',
      description: 'Regular Employee',
      isSystemRole: false,
    },
  ];

  const createdRoles = [];
  for (const roleData of roles) {
    let role = await roleRepository.findOne({ where: { name: roleData.name } });
    if (!role) {
      role = roleRepository.create(roleData);
      role = await roleRepository.save(role);
      console.log(`✅ Created role: ${role.name}`);
    } else {
      console.log(`ℹ️  Role already exists: ${role.name}`);
    }
    createdRoles.push(role);
  }

  // Create permissions
  const permissions = [
    // User management permissions
    { name: 'users:create', description: 'Create users', module: 'HR', action: 'CREATE', resource: 'USER' },
    { name: 'users:read', description: 'Read users', module: 'HR', action: 'READ', resource: 'USER' },
    { name: 'users:update', description: 'Update users', module: 'HR', action: 'UPDATE', resource: 'USER' },
    { name: 'users:delete', description: 'Delete users', module: 'HR', action: 'DELETE', resource: 'USER' },
    
    // Employee management permissions
    { name: 'employees:create', description: 'Create employees', module: 'HR', action: 'CREATE', resource: 'EMPLOYEE' },
    { name: 'employees:read', description: 'Read employees', module: 'HR', action: 'READ', resource: 'EMPLOYEE' },
    { name: 'employees:update', description: 'Update employees', module: 'HR', action: 'UPDATE', resource: 'EMPLOYEE' },
    { name: 'employees:delete', description: 'Delete employees', module: 'HR', action: 'DELETE', resource: 'EMPLOYEE' },
    
    // WFM permissions
    { name: 'schedules:create', description: 'Create schedules', module: 'WFM', action: 'CREATE', resource: 'SCHEDULE' },
    { name: 'schedules:read', description: 'Read schedules', module: 'WFM', action: 'READ', resource: 'SCHEDULE' },
    { name: 'schedules:update', description: 'Update schedules', module: 'WFM', action: 'UPDATE', resource: 'SCHEDULE' },
    { name: 'schedules:delete', description: 'Delete schedules', module: 'WFM', action: 'DELETE', resource: 'SCHEDULE' },
  ];

  const createdPermissions = [];
  for (const permissionData of permissions) {
    let permission = await permissionRepository.findOne({ where: { name: permissionData.name } });
    if (!permission) {
      permission = permissionRepository.create(permissionData);
      permission = await permissionRepository.save(permission);
      console.log(`✅ Created permission: ${permission.name}`);
    } else {
      console.log(`ℹ️  Permission already exists: ${permission.name}`);
    }
    createdPermissions.push(permission);
  }

  // Assign permissions to roles
  const rolePermissions = [
    // System Admin gets all permissions
    { roleName: 'System_Admin', permissions: createdPermissions.map(p => p.name) },
    
    // HR Manager gets HR permissions
    { roleName: 'HR_Manager', permissions: ['users:create', 'users:read', 'users:update', 'users:delete', 'employees:create', 'employees:read', 'employees:update', 'employees:delete'] },
    
    // HR Specialist gets limited HR permissions
    { roleName: 'HR_Specialist', permissions: ['users:read', 'users:update', 'employees:create', 'employees:read', 'employees:update'] },
    
    // WFM Manager gets WFM permissions
    { roleName: 'WFM_Manager', permissions: ['schedules:create', 'schedules:read', 'schedules:update', 'schedules:delete', 'employees:read'] },
    
    // WFM Planner gets limited WFM permissions
    { roleName: 'WFM_Planner', permissions: ['schedules:create', 'schedules:read', 'schedules:update', 'employees:read'] },
    
    // Employee gets basic read permissions
    { roleName: 'Employee', permissions: ['employees:read'] },
  ];

  for (const rolePerm of rolePermissions) {
    const role = createdRoles.find(r => r.name === rolePerm.roleName);
    if (role) {
      // Clear existing permissions
      await rolePermissionRepository.delete({ roleId: role.id });
      
      // Add new permissions
      for (const permName of rolePerm.permissions) {
        const permission = createdPermissions.find(p => p.name === permName);
        if (permission) {
          const rolePermission = rolePermissionRepository.create({
            roleId: role.id,
            permissionId: permission.id,
            grantedAt: new Date(),
          });
          await rolePermissionRepository.save(rolePermission);
        }
      }
      console.log(`✅ Assigned permissions to role: ${role.name}`);
    }
  }

  // Create sample users
  const sampleUsers = [
    {
      email: 'admin@example.com',
      password: 'password123',
      firstName: 'Admin',
      lastName: 'User',
      roles: ['System_Admin'],
    },
    {
      email: 'hr.manager@example.com',
      password: 'password123',
      firstName: 'HR',
      lastName: 'Manager',
      roles: ['HR_Manager'],
    },
    {
      email: 'wfm.manager@example.com',
      password: 'password123',
      firstName: 'WFM',
      lastName: 'Manager',
      roles: ['WFM_Manager'],
    },
    {
      email: 'employee@example.com',
      password: 'password123',
      firstName: 'John',
      lastName: 'Doe',
      roles: ['Employee'],
    },
  ];

  for (const userData of sampleUsers) {
    let user = await userRepository.findOne({ where: { email: userData.email } });
    if (!user) {
      // Hash password
      const hashedPassword = await bcrypt.hash(userData.password, 12);
      
      // Create user
      user = userRepository.create({
        email: userData.email,
        password: hashedPassword,
        firstName: userData.firstName,
        lastName: userData.lastName,
        isActive: true,
        isEmailVerified: true,
      });
      user = await userRepository.save(user);
      console.log(`✅ Created user: ${user.email}`);

      // Assign roles
      for (const roleName of userData.roles) {
        const role = createdRoles.find(r => r.name === roleName);
        if (role) {
          const userRole = userRoleRepository.create({
            userId: user.id,
            roleId: role.id,
            assignedAt: new Date(),
          });
          await userRoleRepository.save(userRole);
        }
      }
      console.log(`✅ Assigned roles to user: ${user.email}`);
    } else {
      console.log(`ℹ️  User already exists: ${user.email}`);
    }
  }

  console.log('🎉 Database seeding completed!');
}

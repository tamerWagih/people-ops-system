import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { Role } from '../entities/role.entity';
import { UserRole } from '../entities/user-role.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { AssignRoleDto } from './dto/assign-role.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Role)
    private readonly roleRepository: Repository<Role>,
    @InjectRepository(UserRole)
    private readonly userRoleRepository: Repository<UserRole>,
  ) {}

  /**
   * Create a new user
   */
  async create(createUserDto: CreateUserDto): Promise<User> {
    // Check if user already exists
    const existingUser = await this.userRepository.findOne({
      where: { email: createUserDto.email },
    });

    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Create user
    const user = this.userRepository.create(createUserDto);
    const savedUser = await this.userRepository.save(user);

    // Assign default role if provided
    if (createUserDto.roleIds && createUserDto.roleIds.length > 0) {
      await this.assignRoles(savedUser.id, createUserDto.roleIds);
    }

    return this.findById(savedUser.id);
  }

  /**
   * Find all users with pagination
   */
  async findAll(page: number = 1, limit: number = 10, search?: string): Promise<{ users: User[]; total: number }> {
    const queryBuilder = this.userRepository
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.userRoles', 'userRole')
      .leftJoinAndSelect('userRole.role', 'role')
      .orderBy('user.createdAt', 'DESC');

    if (search) {
      queryBuilder.where(
        '(user.firstName ILIKE :search OR user.lastName ILIKE :search OR user.email ILIKE :search)',
        { search: `%${search}%` }
      );
    }

    const [users, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return { users, total };
  }

  /**
   * Find user by ID
   */
  async findById(id: string): Promise<User> {
    const user = await this.userRepository.findOne({
      where: { id },
      relations: ['userRoles', 'userRoles.role'],
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return user;
  }

  /**
   * Find user by email
   */
  async findByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { email },
      relations: ['userRoles', 'userRoles.role'],
    });
  }

  /**
   * Update user
   */
  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.findById(id);

    // Check if email is being changed and if it's already taken
    if (updateUserDto.email && updateUserDto.email !== user.email) {
      const existingUser = await this.userRepository.findOne({
        where: { email: updateUserDto.email },
      });

      if (existingUser) {
        throw new ConflictException('User with this email already exists');
      }
    }

    Object.assign(user, updateUserDto);
    const updatedUser = await this.userRepository.save(user);

    return this.findById(updatedUser.id);
  }

  /**
   * Delete user
   */
  async remove(id: string): Promise<void> {
    const user = await this.findById(id);
    await this.userRepository.remove(user);
  }

  /**
   * Assign roles to user
   */
  async assignRoles(userId: string, roleIds: string[]): Promise<User> {
    const user = await this.findById(userId);

    // Get roles
    const roles = await this.roleRepository.findByIds(roleIds);
    if (roles.length !== roleIds.length) {
      throw new NotFoundException('One or more roles not found');
    }

    // Remove existing roles
    await this.userRoleRepository.delete({ userId });

    // Assign new roles
    const userRoles = roleIds.map(roleId => ({
      userId,
      roleId,
      assignedAt: new Date(),
    }));

    await this.userRoleRepository.save(userRoles);

    return this.findById(userId);
  }

  /**
   * Add role to user
   */
  async addRole(userId: string, roleId: string): Promise<User> {
    const user = await this.findById(userId);
    const role = await this.roleRepository.findOne({ where: { id: roleId } });

    if (!role) {
      throw new NotFoundException('Role not found');
    }

    // Check if user already has this role
    const existingUserRole = await this.userRoleRepository.findOne({
      where: { userId, roleId },
    });

    if (existingUserRole) {
      throw new ConflictException('User already has this role');
    }

    await this.userRoleRepository.save({
      userId,
      roleId,
      assignedAt: new Date(),
    });

    return this.findById(userId);
  }

  /**
   * Remove role from user
   */
  async removeRole(userId: string, roleId: string): Promise<User> {
    const user = await this.findById(userId);

    await this.userRoleRepository.delete({ userId, roleId });

    return this.findById(userId);
  }

  /**
   * Update user's last login
   */
  async updateLastLogin(id: string): Promise<void> {
    await this.userRepository.update(id, { lastLoginAt: new Date() });
  }

  /**
   * Update user's password
   */
  async updatePassword(id: string, newPassword: string): Promise<void> {
    const user = await this.findById(id);
    user.password = newPassword; // Will be hashed by @BeforeUpdate
    await this.userRepository.save(user);
  }

  /**
   * Check if user has role
   */
  async hasRole(userId: string, roleName: string): Promise<boolean> {
    const user = await this.findById(userId);
    return user.hasRole(roleName);
  }

  /**
   * Check if user has any of the roles
   */
  async hasAnyRole(userId: string, roleNames: string[]): Promise<boolean> {
    const user = await this.findById(userId);
    return user.hasAnyRole(roleNames);
  }
}

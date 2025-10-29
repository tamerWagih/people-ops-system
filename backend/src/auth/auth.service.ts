import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { PasswordService } from './password.service';
import { SessionService } from './session.service';
import { UserService } from '../users/user.service';
import { LoginLogService } from './login-log.service';

export interface LoginDto {
  email: string;
  password: string;
  rememberMe?: boolean;
}

export interface RegisterDto {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  roles?: string[];
}

export interface AuthResult {
  user: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    roles: string[];
  };
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

@Injectable()
export class AuthService {
  constructor(
    private readonly passwordService: PasswordService,
    private readonly sessionService: SessionService,
    private readonly userService: UserService,
    private readonly loginLogService: LoginLogService,
  ) {}

  /**
   * Validate user credentials
   */
  async validateUser(
    email: string,
    password: string,
    ipAddress?: string,
    userAgent?: string,
  ): Promise<any> {
    // Find user in database
    const user = await this.userService.findByEmail(email);

    if (!user) {
      // Log failed login attempt
      await this.loginLogService.logLoginAttempt(
        null,
        email,
        ipAddress || null,
        userAgent || null,
        false,
        'User not found',
      );
      return null;
    }

    const isPasswordValid = await user.comparePassword(password);

    if (!isPasswordValid) {
      // Log failed login attempt
      await this.loginLogService.logLoginAttempt(
        user.id,
        email,
        ipAddress || null,
        userAgent || null,
        false,
        'Invalid password',
      );
      return null;
    }

    if (!user.isActive) {
      // Log failed login attempt
      await this.loginLogService.logLoginAttempt(
        user.id,
        email,
        ipAddress || null,
        userAgent || null,
        false,
        'Account deactivated',
      );
      throw new UnauthorizedException('Account is deactivated');
    }

    // Update last login
    await this.userService.updateLastLogin(user.id);

    // Log successful login
    await this.loginLogService.logLoginAttempt(
      user.id,
      email,
      ipAddress || null,
      userAgent || null,
      true,
    );

    // Return user without password
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { password: _, ...result } = user;
    
    // Ensure roles are included and properly typed
    const userResult = {
      ...result,
      roles: user.roles || [],
    };
    
    return userResult;
  }

  /**
   * Login user
   */
  async login(loginDto: LoginDto, ipAddress?: string, userAgent?: string): Promise<AuthResult> {
    const user = await this.validateUser(loginDto.email, loginDto.password, ipAddress, userAgent);
    
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const sessionId = this.sessionService.generateSessionId();
    
    // Debug: Log user roles
    console.log('User roles during login:', user.roles);
    
    const { accessToken, refreshToken } = this.sessionService.generateTokenPair(
      user.id,
      user.email,
      user.roles || [],
      sessionId,
    );

    // TODO: Store session in database
    // TODO: Set different expiration based on rememberMe

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        roles: user.roles,
      },
      accessToken,
      refreshToken,
      expiresIn: 15 * 60, // 15 minutes in seconds
    };
  }

  /**
   * Register new user
   */
  async register(registerDto: RegisterDto): Promise<AuthResult> {
    // Validate password strength
    const passwordValidation = this.passwordService.validatePasswordStrength(
      registerDto.password,
    );

    if (!passwordValidation.isValid) {
      throw new BadRequestException({
        message: 'Password does not meet requirements',
        errors: passwordValidation.errors,
      });
    }

    // Create user in database
    const newUser = await this.userService.create({
      email: registerDto.email,
      password: registerDto.password,
      firstName: registerDto.firstName,
      lastName: registerDto.lastName,
      roleIds: registerDto.roles ? await this.getRoleIdsByName(registerDto.roles) : [],
    });

    const sessionId = this.sessionService.generateSessionId();
    const { accessToken, refreshToken } = this.sessionService.generateTokenPair(
      newUser.id,
      newUser.email,
      newUser.roles,
      sessionId,
    );

    return {
      user: {
        id: newUser.id,
        email: newUser.email,
        firstName: newUser.firstName,
        lastName: newUser.lastName,
        roles: newUser.roles,
      },
      accessToken,
      refreshToken,
      expiresIn: 15 * 60,
    };
  }

  /**
   * Refresh access token
   */
  async refreshToken(refreshToken: string): Promise<{ accessToken: string; expiresIn: number }> {
    const payload = this.sessionService.verifyToken(refreshToken);
    
    if (!payload || payload.type !== 'refresh') {
      throw new UnauthorizedException('Invalid refresh token');
    }

    // TODO: Verify session exists in database
    // TODO: Check if user is still active

    // Mock user data
    const user = {
      id: payload.sub,
      email: 'admin@example.com',
      roles: ['System_Admin'],
    };

    const sessionId = this.sessionService.generateSessionId();
    const accessToken = this.sessionService.generateAccessToken({
      sub: user.id,
      email: user.email,
      roles: user.roles,
      sessionId,
    });

    return {
      accessToken,
      expiresIn: 15 * 60,
    };
  }

  /**
   * Logout user
   */
  async logout(sessionId: string): Promise<void> {
    // TODO: Invalidate session in database
    // TODO: Add token to blacklist
    console.log(`Logging out session: ${sessionId}`);
  }

  /**
   * Change password
   */
  async changePassword(
    userId: string,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    // Get user from database
    const user = await this.userService.findById(userId);

    // Verify current password
    const isCurrentPasswordValid = await user.comparePassword(currentPassword);

    if (!isCurrentPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    // Validate new password strength
    const passwordValidation = this.passwordService.validatePasswordStrength(newPassword);
    if (!passwordValidation.isValid) {
      throw new BadRequestException({
        message: 'New password does not meet requirements',
        errors: passwordValidation.errors,
      });
    }

    // Update password in database
    await this.userService.updatePassword(userId, newPassword);
  }

  /**
   * Helper method to get role IDs by names
   */
  private async getRoleIdsByName(_roleNames: string[]): Promise<string[]> {
    // This would need to be implemented in UserService
    // For now, return empty array
    return [];
  }
}

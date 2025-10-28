import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { PasswordService } from './password.service';
import { SessionService } from './session.service';

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
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    private readonly passwordService: PasswordService,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    private readonly sessionService: SessionService,
  ) {}

  /**
   * Validate user credentials
   */
  async validateUser(email: string, password: string): Promise<any> {
    // TODO: Replace with actual database query
    // For now, we'll use mock data
    const mockUser = {
      id: '1',
      email: 'admin@example.com',
      password: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeHdKz8z8z8z8z8z8z', // 'password123'
      firstName: 'Admin',
      lastName: 'User',
      roles: ['System_Admin'],
      isActive: true,
    };

    if (mockUser.email !== email) {
      return null;
    }

    const isPasswordValid = await this.passwordService.comparePassword(
      password,
      mockUser.password,
    );

    if (!isPasswordValid) {
      return null;
    }

    if (!mockUser.isActive) {
      throw new UnauthorizedException('Account is deactivated');
    }

    // Remove password from returned object
    const { password: _, ...result } = mockUser;
    return result;
  }

  /**
   * Login user
   */
  async login(loginDto: LoginDto): Promise<AuthResult> {
    const user = await this.validateUser(loginDto.email, loginDto.password);
    
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const sessionId = this.sessionService.generateSessionId();
    const { accessToken, refreshToken } = this.sessionService.generateTokenPair(
      user.id,
      user.email,
      user.roles,
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

    // TODO: Check if user already exists
    // TODO: Create user in database

    await this.passwordService.hashPassword(registerDto.password);
    
    // Mock user creation
    const newUser = {
      id: '2',
      email: registerDto.email,
      firstName: registerDto.firstName,
      lastName: registerDto.lastName,
      roles: registerDto.roles || ['Employee'],
      isActive: true,
    };

    const sessionId = this.sessionService.generateSessionId();
    const { accessToken, refreshToken } = this.sessionService.generateTokenPair(
      newUser.id,
      newUser.email,
      newUser.roles,
      sessionId,
    );

    return {
      user: newUser,
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
    // TODO: Get user from database
    const user = {
      id: userId,
      password: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeHdKz8z8z8z8z8z8z',
    };

    // Verify current password
    const isCurrentPasswordValid = await this.passwordService.comparePassword(
      currentPassword,
      user.password,
    );

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

    // Hash new password
    await this.passwordService.hashPassword(newPassword);
    
    // TODO: Update password in database
    console.log(`Password changed for user: ${userId}`);
  }
}

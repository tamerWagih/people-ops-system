import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { PasswordService } from './password.service';
import { SessionService } from './session.service';
import { UserService } from '../users/user.service';

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
    private readonly userService: UserService,
  ) {}

  /**
   * Validate user credentials
   */
  async validateUser(email: string, password: string): Promise<any> {
    // Find user in database
    const user = await this.userService.findByEmail(email);

    if (!user) {
      return null;
    }

    const isPasswordValid = await user.comparePassword(password);

    if (!isPasswordValid) {
      return null;
    }

    if (!user.isActive) {
      throw new UnauthorizedException('Account is deactivated');
    }

    // Update last login
    await this.userService.updateLastLogin(user.id);

    // Return user without password
    const { password: _, ...result } = user;
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
  private async getRoleIdsByName(roleNames: string[]): Promise<string[]> {
    // This would need to be implemented in UserService
    // For now, return empty array
    return [];
  }
}

import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

export interface RefreshTokenPayload {
  sub: string; // user ID
  type: 'refresh';
  sessionId: string;
}

export interface AccessTokenPayload {
  sub: string; // user ID
  type: 'access';
  email: string;
  roles: string[];
  sessionId: string;
}

@Injectable()
export class SessionService {
  constructor(
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    private readonly jwtService: JwtService,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    private readonly configService: ConfigService,
  ) {}

  /**
   * Generate access token
   */
  generateAccessToken(payload: Omit<AccessTokenPayload, 'type'>): string {
    const tokenPayload: AccessTokenPayload = {
      ...payload,
      type: 'access',
    };

    return this.jwtService.sign(tokenPayload, {
      expiresIn: this.configService.get<string>('JWT_EXPIRES_IN') || '15m',
    });
  }

  /**
   * Generate refresh token
   */
  generateRefreshToken(payload: Omit<RefreshTokenPayload, 'type'>): string {
    const tokenPayload: RefreshTokenPayload = {
      ...payload,
      type: 'refresh',
    };

    return this.jwtService.sign(tokenPayload, {
      expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRES_IN') || '7d',
    });
  }

  /**
   * Generate both access and refresh tokens
   */
  generateTokenPair(
    userId: string,
    email: string,
    roles: string[],
    sessionId: string,
  ): { accessToken: string; refreshToken: string } {
    const accessToken = this.generateAccessToken({
      sub: userId,
      email,
      roles,
      sessionId,
    });

    const refreshToken = this.generateRefreshToken({
      sub: userId,
      sessionId,
    });

    return { accessToken, refreshToken };
  }

  /**
   * Verify and decode a token
   */
  verifyToken<T = any>(token: string): T | null {
    try {
      return this.jwtService.verify(token) as T;
    } catch {
      return null;
    }
  }

  /**
   * Extract token from Authorization header
   */
  extractTokenFromHeader(authHeader: string): string | null {
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return null;
    }
    return authHeader.substring(7);
  }

  /**
   * Generate a unique session ID
   */
  generateSessionId(): string {
    return `sess_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Check if token is expired
   */
  isTokenExpired(token: string): boolean {
    try {
      const decoded = this.jwtService.verify(token, { ignoreExpiration: true });
      const now = Math.floor(Date.now() / 1000);
      return decoded.exp < now;
    } catch {
      return true;
    }
  }
}

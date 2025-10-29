import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { LocalStrategy } from './strategies/local.strategy';
import { PasswordService } from './password.service';
import { SessionService } from './session.service';
import { LoginLogService } from './login-log.service';
import { AuditLogService } from './audit-log.service';
import { LoginLog } from '../entities/login-log.entity';
import { AuditLog } from '../entities/audit-log.entity';
import { UserModule } from '../users/user.module';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET') || 'your-secret-key',
        signOptions: {
          expiresIn: configService.get<string>('JWT_EXPIRES_IN') || '15m',
        },
      }),
      inject: [ConfigService],
    }),
    TypeOrmModule.forFeature([LoginLog, AuditLog]),
    UserModule,
  ],
  providers: [
    AuthService,
    PasswordService,
    SessionService,
    LoginLogService,
    AuditLogService,
    JwtStrategy,
    LocalStrategy,
  ],
  controllers: [AuthController],
  exports: [
    AuthService,
    PasswordService,
    SessionService,
    LoginLogService,
    AuditLogService,
  ],
})
export class AuthModule {}

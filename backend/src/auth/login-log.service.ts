import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LoginLog } from '../entities/login-log.entity';

@Injectable()
export class LoginLogService {
  constructor(
    @InjectRepository(LoginLog)
    private readonly loginLogRepository: Repository<LoginLog>,
  ) {}

  /**
   * Log login attempt
   */
  async logLoginAttempt(
    userId: string | null,
    username: string | null,
    ipAddress: string | null,
    userAgent: string | null,
    loginSuccessful: boolean,
    failureReason?: string,
  ): Promise<LoginLog> {
    const loginLog = this.loginLogRepository.create({
      userId: userId || undefined,
      username: username || undefined,
      ipAddress: ipAddress || undefined,
      userAgent: userAgent || undefined,
      loginSuccessful,
      failureReason: failureReason || undefined,
    });

    return this.loginLogRepository.save(loginLog);
  }

  /**
   * Get login logs for a user
   */
  async getUserLoginLogs(userId: string, limit: number = 50): Promise<LoginLog[]> {
    return this.loginLogRepository.find({
      where: { userId },
      order: { loginTime: 'DESC' },
      take: limit,
    });
  }

  /**
   * Get failed login attempts for a user
   */
  async getFailedLoginAttempts(username: string, hours: number = 24): Promise<number> {
    const since = new Date();
    since.setHours(since.getHours() - hours);

    return this.loginLogRepository
      .createQueryBuilder('loginLog')
      .where('loginLog.username = :username', { username })
      .andWhere('loginLog.loginSuccessful = :successful', { successful: false })
      .andWhere('loginLog.loginTime >= :since', { since })
      .getCount();
  }
}

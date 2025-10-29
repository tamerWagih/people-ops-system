import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository } from 'typeorm';
import { Employee } from '../entities/employee.entity';
import { CreateEmployeeDto } from './dto/create-employee.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { AuditLogService } from '../auth/audit-log.service';

@Injectable()
export class EmployeeService {
  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    private readonly auditLogService: AuditLogService,
  ) {}

  async create(dto: CreateEmployeeDto, actorId?: string, ip?: string, ua?: string): Promise<Employee> {
    // Check unique fields
    const exists = await this.employeeRepository.findOne({ where: [{ employeeId: dto.employeeId }, { nationalId: dto.nationalId }] });
    if (exists) {
      throw new ConflictException('Employee with same ID/nationalId already exists');
    }
    const entity = this.employeeRepository.create(dto);
    const saved = await this.employeeRepository.save(entity);
    await this.auditLogService.log({ tableName: 'employees', recordId: saved.id, action: 'INSERT', newValues: { ...saved } as unknown as Record<string, unknown>, changedBy: actorId, ipAddress: ip, userAgent: ua });
    return saved;
  }

  async findAll(page = 1, limit = 10, search?: string, sort = 'createdAt', order: 'ASC' | 'DESC' = 'DESC') {
    const qb = this.employeeRepository.createQueryBuilder('e');
    if (search) {
      qb.where(
        'e.firstName ILIKE :s OR e.lastName ILIKE :s OR e.employeeId ILIKE :s OR e.department ILIKE :s OR e.position ILIKE :s',
        { s: `%${search}%` }
      );
    }
    qb.orderBy(`e.${sort}`, order)
      .skip((page - 1) * limit)
      .take(limit);
    const [items, total] = await qb.getManyAndCount();
    return { items, total, page, limit };
  }

  async findOne(id: string): Promise<Employee> {
    const emp = await this.employeeRepository.findOne({ where: { id } });
    if (!emp) throw new NotFoundException('Employee not found');
    return emp;
  }

  async update(id: string, dto: UpdateEmployeeDto, actorId?: string, ip?: string, ua?: string): Promise<Employee> {
    const emp = await this.findOne(id);
    const oldValues = { ...emp } as unknown as Record<string, unknown>;
    Object.assign(emp, dto);
    const saved = await this.employeeRepository.save(emp);
    await this.auditLogService.log({ tableName: 'employees', recordId: saved.id, action: 'UPDATE', oldValues, newValues: { ...saved } as unknown as Record<string, unknown>, changedBy: actorId, ipAddress: ip, userAgent: ua });
    return saved;
  }

  async remove(id: string, actorId?: string, ip?: string, ua?: string): Promise<void> {
    const emp = await this.findOne(id);
    await this.employeeRepository.remove(emp);
    await this.auditLogService.log({ tableName: 'employees', recordId: id, action: 'DELETE', oldValues: { ...emp } as unknown as Record<string, unknown>, changedBy: actorId, ipAddress: ip, userAgent: ua });
  }
}



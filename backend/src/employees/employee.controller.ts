import { Body, Controller, Delete, Get, Param, Post, Put, Query, Request, UseGuards } from '@nestjs/common';
import { EmployeeService } from './employee.service';
import { CreateEmployeeDto } from './dto/create-employee.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Permissions } from '../auth/decorators/permissions.decorator';
import { PermissionsGuard } from '../auth/guards/permissions.guard';

@Controller('api/employees')
@UseGuards(JwtAuthGuard, PermissionsGuard)
export class EmployeeController {
  constructor(private readonly employeeService: EmployeeService) {}

  @Post()
  @Permissions('employees:CREATE')
  async create(@Body() dto: CreateEmployeeDto, @Request() req) {
    const actorId = req.user?.userId;
    const ip = req.ip || req.headers['x-forwarded-for'] || req.connection?.remoteAddress;
    const ua = req.headers['user-agent'];
    return this.employeeService.create(dto, actorId, ip, ua);
  }

  @Get()
  @Permissions('employees:READ')
  async findAll(
    @Query('page') page = 1,
    @Query('limit') limit = 10,
    @Query('search') search?: string,
    @Query('sort') sort = 'createdAt',
    @Query('order') order: 'ASC' | 'DESC' = 'DESC',
  ) {
    return this.employeeService.findAll(Number(page), Number(limit), search, sort, order);
  }

  @Get(':id')
  @Permissions('employees:READ')
  async findOne(@Param('id') id: string) {
    return this.employeeService.findOne(id);
  }

  @Put(':id')
  @Permissions('employees:UPDATE')
  async update(@Param('id') id: string, @Body() dto: UpdateEmployeeDto, @Request() req) {
    const actorId = req.user?.userId;
    const ip = req.ip || req.headers['x-forwarded-for'] || req.connection?.remoteAddress;
    const ua = req.headers['user-agent'];
    return this.employeeService.update(id, dto, actorId, ip, ua);
  }

  @Delete(':id')
  @Permissions('employees:DELETE')
  async remove(@Param('id') id: string, @Request() req) {
    const actorId = req.user?.userId;
    const ip = req.ip || req.headers['x-forwarded-for'] || req.connection?.remoteAddress;
    const ua = req.headers['user-agent'];
    await this.employeeService.remove(id, actorId, ip, ua);
    return { success: true };
  }
}



import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  HttpException,
  NotFoundException,
  Post,
  Query,
  UseGuards
} from '@nestjs/common';
import { AccessTokenGuard } from '../guards/accessToken.guard';
import { User } from '../models/user';

@Controller()
export class AppController {
  @Get('users')
  public getUsers(): User[] {
    return [User.mock(), User.mock(), User.mock()];
  }

  @Get('user')
  public getUser(@Query('id') id?: string): User {
    if (!id) {
      throw new NotFoundException('User not found');
    }
    return User.mock({ id });
  }

  @Post('user')
  public createUser(@Body() user?: User): User {
    if (!user) {
      throw new BadRequestException('Invalid body format');
    }
    console.log(user);
    return User.mock({ id: user.id, username: user.username });
  }

  @Delete('user')
  public deleteUser(@Query('id') id?: string): void {
    if (!id) {
      throw new BadRequestException('Invalid query format');
    }
  }

  @Get('error')
  public getError(): void {
    throw new HttpException('Internal server error', 500);
  }

  @Get('private')
  @UseGuards(AccessTokenGuard)
  public getPrivate(): User {
    console.log('Test');
    return User.mock();
  }
}

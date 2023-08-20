import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  HttpException,
  InternalServerErrorException,
  NotFoundException,
  Post,
  Query,
  Res,
  UploadedFile,
  UseGuards,
  UseInterceptors
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import * as fs from 'fs';
import * as path from 'path';
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
    return User.mock();
  }

  @Post('image')
  @UseInterceptors(FileInterceptor('image'))
  public uploadImage(@UploadedFile() imageFile: Express.Multer.File, @Res() res: Response): void {
    if (!imageFile) {
      throw new InternalServerErrorException('Invalid body format');
    }

    const imagesDir: string = path.join(__dirname, '..', '..', 'public', 'images');
    if (!fs.existsSync(imagesDir)) {
      fs.mkdirSync(imagesDir, { recursive: true });
    }

    const imagePath: string = path.join(__dirname, '..', '..', 'public', 'images', imageFile.originalname);
    fs.writeFileSync(imagePath, imageFile.buffer);

    res.setHeader('Content-Type', imageFile.mimetype);

    const filePath: string = path.join(__dirname, '..', '..', 'public', 'images', imageFile.originalname);
    const fileStream: fs.ReadStream = fs.createReadStream(filePath);
    fileStream.pipe(res);
  }
}

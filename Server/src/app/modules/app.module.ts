import { Module } from '@nestjs/common';
import { AppController } from '../controllers/app.controller';

@Module({
  controllers: [AppController]
})
export class AppModule {}

import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Optional } from '../../utils/optional';

@Injectable()
export class AccessTokenGuard implements CanActivate {
  public async canActivate(context: ExecutionContext): Promise<boolean> {
    const accessToken: Optional<string> = this.getAccessTokenFromContext(context);
    if (!accessToken) {
      return false;
    }

    if (accessToken !== 'valid_access_token') {
      return false;
    }
    return true;
  }

  private getAccessTokenFromContext(context: ExecutionContext): Optional<string> {
    switch (context.getType()) {
      case 'http':
        const httpRequest: Request = context.switchToHttp().getRequest();
        return this.getAccessTokenFromRequest(httpRequest);
      default:
        return undefined;
    }
  }

  private getAccessTokenFromRequest(request: Request): Optional<string> {
    const authorizationHeader: Optional<string> = request.headers['authorization'];
    if (!authorizationHeader) {
      return undefined;
    }
    return this.parseAccessToken(authorizationHeader);
  }

  private parseAccessToken(authorization: string): Optional<string> {
    const elements: string[] = authorization.split(' ');
    const tokenType: Optional<string> = elements[0];
    if (tokenType.toLocaleLowerCase() === 'bearer') {
      return elements[1];
    }
    return undefined;
  }
}

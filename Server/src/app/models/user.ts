import { faker } from '@faker-js/faker';

export class User {
  public constructor(public id: string, public username: string) {}

  public static mock(args?: Partial<User>): User {
    return new User(args?.id ?? faker.string.uuid(), args?.username ?? faker.internet.displayName());
  }
}

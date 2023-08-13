module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    sourceType: 'module'
  },
  settings: {
    'import/resolver': {
      node: {
        moduleDirectory: ['node_modules', './']
      }
    }
  },
  plugins: [
    '@typescript-eslint/eslint-plugin',
    'eslint-plugin-import',
    'eslint-plugin-prettier',
    'eslint-plugin-promise',
    'promise'
  ],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
    'plugin:import/errors',
    'plugin:import/typescript',
    'plugin:promise/recommended'
  ],
  root: true,
  env: {
    node: true,
    jest: true
  },
  rules: {
    'prettier/prettier': [
      'error',
      {
        printWidth: 120,
        trailingComma: 'none',
        tabWidth: 2,
        semi: true,
        singleQuote: true
      }
    ],
    'import/no-unresolved': 'off',
    'no-shadow': 'off',
    'no-case-declarations': 'off',
    'promise/param-names': 'off',
    'promise/always-return': 'off',
    '@typescript-eslint/no-var-requires': 'off',
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
    '@typescript-eslint/no-unused-vars': [
      'warn',
      {
        vars: 'all',
        varsIgnorePattern: '^_',
        args: 'all',
        argsIgnorePattern: '^_',
        caughtErrors: 'none'
      }
    ],
    '@typescript-eslint/no-use-before-define': 'off',
    '@typescript-eslint/quotes': ['error', 'single', { avoidEscape: true }],
    'comma-dangle': ['error', 'never'],
    '@typescript-eslint/comma-spacing': [2, { before: false, after: true }],
    'max-len': ['warn', { code: 120, ignoreStrings: true, ignoreRegExpLiterals: true, ignoreComments: true }],
    'max-lines': ['error', 1050],
    'no-empty': ['error'],
    eqeqeq: ['error'],
    '@typescript-eslint/no-shadow': 'off',
    '@typescript-eslint/no-empty-interface': ['error'],
    curly: ['error'],
    '@typescript-eslint/no-inferrable-types': 'off',
    '@typescript-eslint/typedef': [
      'warn',
      {
        arrayDestructuring: true,
        arrowParameter: false,
        memberVariableDeclaration: true,
        objectDestructuring: true,
        parameter: true,
        propertyDeclaration: true,
        variableDeclaration: true
      }
    ],
    '@typescript-eslint/explicit-function-return-type': ['warn'],
    '@typescript-eslint/explicit-member-accessibility': ['error'],
    '@typescript-eslint/explicit-module-boundary-types': ['error', { allowArgumentsExplicitlyTypedAsAny: true }],
    '@typescript-eslint/ban-types': ['error', { types: { Object: false } }],
    '@typescript-eslint/naming-convention': [
      'error',
      {
        selector: ['method'],
        format: ['camelCase']
      },
      {
        selector: ['function'],
        format: ['camelCase', 'PascalCase']
      },
      {
        selector: ['class', 'interface', 'enum', 'typeAlias', 'typeParameter'],
        format: ['PascalCase']
      },
      {
        selector: 'variable',
        format: ['camelCase', 'UPPER_CASE']
      },
      {
        selector: 'classProperty',
        format: ['camelCase', 'snake_case']
      },
      {
        selector: 'enumMember',
        format: ['camelCase']
      }
    ],
    '@typescript-eslint/member-ordering': ['error']
  }
};

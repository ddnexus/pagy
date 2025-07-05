import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import alignAssignments from 'eslint-plugin-align-assignments';
import pluginCypress from 'eslint-plugin-cypress/flat'

export default tseslint.config(
  {
    // We lint only typescript sources and tests. Everything else is generated.
    files: ['src/pagy.ts', 'e2e/cypress/*.ts', 'e2e/cypress.config.ts'],
    extends: [
      eslint.configs.recommended,
      ...tseslint.configs.recommended,
      ...tseslint.configs.recommendedTypeChecked,
      ...tseslint.configs.strict,  // opinionated but ok for now
      ],
    plugins: {
      alignAssignments: alignAssignments,
      '@typescript-eslint': tseslint.plugin,
    },
    languageOptions: {
      parser: tseslint.parser,
        parserOptions: {
        project: true,
      },
    },
    rules: {
      'alignAssignments/align-assignments': 'warn',
      'semi': ["warn", "always", {"omitLastInOneLineBlock": true}],
      '@typescript-eslint/array-type': 'error',
      '@typescript-eslint/consistent-type-imports': 'error',
      '@typescript-eslint/no-unsafe-argument': 'error',
      '@typescript-eslint/no-unsafe-assignment': 'error',
      '@typescript-eslint/no-unsafe-call': 'error',
      '@typescript-eslint/no-unsafe-member-access': 'error',
      '@typescript-eslint/no-unsafe-return': 'error',
    }
  },
  {
    files: ['e2e/cypress/*.ts', 'e2e/cypress.config.ts'],
    ...pluginCypress.configs.recommended,
    rules: {
      'cypress/no-unnecessary-waiting': 'warn',
      'cypress/unsafe-to-chain-command': 'error',
    }
  }
);

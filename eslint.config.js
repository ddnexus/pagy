import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import { defineConfig } from 'eslint/config';
import alignAssignments from 'eslint-plugin-align-assignments';
import stylistic from '@stylistic/eslint-plugin';

export default defineConfig([
  {
    files: ['src/pagy.ts'],
    extends: [
      eslint.configs.recommended,
      ...tseslint.configs.recommendedTypeChecked,
      ...tseslint.configs.strictTypeChecked,
    ],
    plugins: {
      'align-assignments': alignAssignments,
      '@stylistic': stylistic,
    },
    languageOptions: {
      parserOptions: {
        // project: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      'align-assignments/align-assignments': 'warn',
      // Stylistic replacements
      '@stylistic/semi': ["warn", "always", { "omitLastInOneLineBlock": true }],
      '@stylistic/key-spacing': ['warn', { align: 'colon' }],

      // TypeScript rules
      '@typescript-eslint/array-type': 'error',
      '@typescript-eslint/consistent-type-imports': 'error',
      '@typescript-eslint/no-unsafe-argument': 'error',
      '@typescript-eslint/no-unsafe-assignment': 'error',
      '@typescript-eslint/no-unsafe-call': 'error',
      '@typescript-eslint/no-unsafe-member-access': 'error',
      '@typescript-eslint/no-unsafe-return': 'error',
    }
  }
]);

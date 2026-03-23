import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";
import unusedImports from "eslint-plugin-unused-imports";
import importPlugin from "eslint-plugin-import";

export default defineConfig([
  ...nextVitals,
  ...nextTs,

  {
    plugins: {
      "unused-imports": unusedImports,
      import: importPlugin,
    },

    rules: {
      /*
       * Formatting / style
       */
      semi: ["error", "always"],
      "comma-dangle": ["error", "always-multiline"],
      indent: ["error", 4],
      "brace-style": ["error", "1tbs", { allowSingleLine: true }],
      "object-curly-spacing": ["error", "always"],
      "array-bracket-spacing": ["error", "never"],

      /*
       * Other
       */
      "react/jsx-indent": ["error", 4],
      "react/jsx-indent-props": ["error", 4],
      "no-unused-vars": "warn",
      "unused-imports/no-unused-imports": "error",
      "import/no-cycle": "warn",
      "import/order": [
        "warn",
        {
          groups: ["builtin", "external", "internal", "parent", "sibling", "index"],
          "newlines-between": "always",
        },
      ],
      "no-await-in-loop": "warn",
    },
  },

  globalIgnores([".next/**", "out/**", "build/**", "next-env.d.ts"]),
]);

# Visual Studio Code / Code - OSS / VSCodium Configuration


# Install
- Settings:
  - If you want to use my `settings.json` file as-is:
    ```shell
    ln -s "${TIMZWIEBEL_LINUX}/config/vscode/settings.json" ~/.config/Code\ -\ OSS/User/settings.json
    ```
  - Alternatively, you can simply copy/paste parts of my `settings.json` file
    into your `~/.config/Code\ -\ OSS/User/settings.json` file.
- Keybindings:
  - If you want to use my `keybindings.json` file as-is:
    ```shell
    ln -s "${TIMZWIEBEL_LINUX}/config/vscode/keybindings.json" ~/.config/Code\ -\ OSS/User/keybindings.json
    ```
- Snippets:
  - If you want to use one of my snippets files:
    ```shell
    ln -s "${TIMZWIEBEL_LINUX}/config/vscode/snippets/<snippet_file>" ~/.config/Code\ -\ OSS/User/snippets/<snippet_file>
    ```
  - If you want to use *all* of my snippets files:
    ```shell
    ln -s "${TIMZWIEBEL_LINUX}/config/vscode/snippets" ~/.config/Code\ -\ OSS/User/snippets
    ```


# Links
- Releases:
  - [Visual Studio Code](https://code.visualstudio.com): the proprietary
    Microsoft-branded release
  - [Code - OSS](https://github.com/microsoft/vscode): the official
    Microsoft-driven open-source release
  - [VSCodium](https://vscodium.com): a community-driven open-source release
- Extensions:
  - [Visual Studio Marketplace](https://marketplace.visualstudio.com/vscode):
    the official Microsoft-run marketplace (the terms only permit it to be used
    with the official Microsoft-branded release)
  - [Open VSX Registry](https://open-vsx.org): a vendor-neutral open-source
    alternative to the Visual Studio Marketplace
- [Snippets Documentation](https://code.visualstudio.com/docs/editor/userdefinedsnippets):
  how to make and use snippets in Visual Studio Code


# Extensions
- General:
  - **Rewrap**
    ([Marketplace](https://marketplace.visualstudio.com/items?itemName=stkb.rewrap),
    [Open VSX](https://open-vsx.org/extension/stkb/rewrap)): press `Alt+Q` to
    rewrap plain text/comments to rulers or a specified wrapping column
  - **Local History**
    ([Marketplace](https://marketplace.visualstudio.com/items?itemName=xyz.local-history),
    [Open VSX](https://open-vsx.org/extension/xyz/local-history)): maintains local
    history of files so that every time you modify a file, a copy of the old
    contents is kept in the local history, in case you change or delete a file by
    accident
  - **Thunder Client**
    ([Marketplace](https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client),
    [Open VSX](https://open-vsx.org/extension/rangav/vscode-thunder-client)): a
    lightweight Rest API Client for testing/debugging APIs
- Language-specific:
  - **Python**
    ([Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.python),
    [Open VSX](https://open-vsx.org/extension/ms-python/python)): IntelliSense
    (Pylance), linting, debugging, code navigation, code formatting,
    refactoring, variable explorer, test explorer, and more
    - **isort**
      ([Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.isort),
      [Open VSX](https://open-vsx.org/extension/ms-python/isort)): provides
      import sorting using `isort`
  - **Svelte for VS Code**
    ([Marketplace](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode),
    [Open VSX](https://open-vsx.org/extension/svelte/svelte-vscode)): provides
    syntax highlighting and rich intellisense for Svelte components
  - **Tailwind CSS IntelliSense**
    ([Marketplace](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss),
    [Open VSX](https://open-vsx.org/extension/bradlc/vscode-tailwindcss)):
    autocomplete, syntax highlighting, and linting for Tailwind CSS

// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Ethir Documentation',
  tagline: 'A blockspace futures market, for the future',
  url: 'https://adithyanarayan.github.io/',
  baseUrl: '/ethir/docs',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'adithyanarayan', // Usually your GitHub org/user name.
  projectName: 'ethir', // Usually your repo name.

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          path: 'protocol',
          routeBasePath: '/protocol',
          sidebarPath: require.resolve('./sidebars.js'),
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/adithyanarayan/ethir/tree/main/docs/',
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],
  plugins: [
    // [
    //   '@docusaurus/plugin-content-docs',
    //   {
    //     id: 'protocol',
    //     path: 'protocol',
    //     routeBasePath: 'protocol/',
    //     remarkPlugins: [[require('@docusaurus/remark-plugin-npm2yarn'), { sync: true }]],
    //     includeCurrentVersion: true,
    //   },
    // ],
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'dev',
        path: 'dev',
        routeBasePath: 'dev/',
        remarkPlugins: [[require('@docusaurus/remark-plugin-npm2yarn'), { sync: true }]],
        includeCurrentVersion: true,
      },
    ],
  ],

 themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: 'Ethir Docs',
        logo: {
          alt: 'Ethir Logo',
          src: 'img/logo.svg',
        },
        items: [
          {
            // type: 'doc',
            to: '/protocol/overview',
            // docId: 'intro',
            position: 'left',
            label: 'Protocol',
          },
          {
            // type: 'doc',
            to: '/dev/intro',
            position: 'left',
            label: 'Developers',
          },
          {
            to: '/simulator',
            position: 'left',
            label: 'Simulator',
          },
          {
            href: 'https://github.com/adithyanarayan/ethir',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Protocol',
                to: '/protocol',
              },
              {
                label: 'Developers',
                to: '/dev',
              },
            ],
          },
          {
            title: 'Community',
            items: [
              {
                label: 'Discord',
                href: 'https://discordapp.com/invite/docusaurus',
              },
              {
                label: 'Twitter',
                href: 'https://twitter.com/deltamale_',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'GitHub',
                href: 'https://github.com/adithyanarayan/ethir',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Adithya Narayan. Built with Docusaurus.`,
      },
      prism: {
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;

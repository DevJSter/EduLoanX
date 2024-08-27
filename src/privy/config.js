import { Sepolia } from "./chains";

export const privyConfig = {
  appId: "cltn4pfm807ld12sf83bqr3iy",
  config: {
    logo: "https://your.logo.url",
    appearance: { theme: "dark" },
    loginMethods: ["wallet"],
    appearance: {
      walletList: ["metamask", "detected_wallets", "rainbow"],
      theme: "dark",
    },
    defaultChain: Sepolia,
    supportedChains: [Sepolia],
    embeddedWallets: {
      createOnLogin: "users-without-wallets",
    },
  },
};

import { toast } from "sonner";

export const chainsName = { sepolia: "SepoliaEth" };

export const Sepolia = {
  id: 11155111,
  network: "Sepolia Ether Testnet",
  name: "SepoliaEth",
  nativeCurrency: {
    name: "ETH",
    symbol: "Eth",
    decimals: 18,
  },
  rpcUrls: {
    default: {
      http: ["https://mainnet.infura.io/v3/"],
    },
    public: {
      http: ["https://mainnet.infura.io/v3/"],
    },
  },
  blockExplorers: {
    default: {
      name: "Explorer",
      url: "https://sepolia.etherscan.io",
    },
  },
};

export async function switchToSepolia(w0, setter) {
  try {
    const provider = await w0?.getEthersProvider();
    const res = await provider?.send("wallet_addEthereumChain", [
      {
        chainId: "1",
        chainName: "Sepolia Ether Testnet",
        nativeCurrency: {
          name: "SepoliaEth",
          symbol: "SepoliaEth",
          decimals: 18,
        },
        rpcUrls: ["https://mainnet.infura.io/v3/"],
        blockExplorerUrls: ["https://explorer.testnet.inco.org"],
      },
    ]);

    const network = await provider.detectNetwork();
    if (network.chainId === 1) {
      setter(chainsName.sepolia);
    }
  } catch (error) {
    console.log(error?.message);
    toast(error?.message);
  }
}

import { Inter, Lexend_Deca } from "next/font/google";
import "./globals.css";
import { Toaster } from "@/components/ui/sonner";
import PrivyWrapper from "@/privy/privyProvider";
import ReduxProvider from "@/redux/redux-provider";

const inter = Inter({ subsets: ["latin"] });
const lexendDeca = Lexend_Deca({ subsets: ["latin"] });

export const metadata = {
  title: "EduLoanX",
  description: "Generated by create next app",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={lexendDeca.className}>
        <PrivyWrapper>
          <ReduxProvider>{children}</ReduxProvider>
          <Toaster />
        </PrivyWrapper>
      </body>
    </html>
  );
}

import { Button } from "@/components/ui/button";
import Link from "next/link";
import { usePrivy } from "@privy-io/react-auth";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "./ui/dropdown-menu";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import Image from "next/image";

export default function Login() {
  const { login } = usePrivy();
  // const [selectedUser, setSelectedUser] = useState("beneficiary");
  const router = useRouter();

  const handleLogin = (selectedUser) => {
    if (selectedUser === "admin") {
      login();
      router.push("/owner");
    } else {
      login();
      router.push("/");
    }
  };

  return (
    <div className="relative flex min-h-screen flex-col items-center justify-center p-3.5">
      <main className="flex flex-col items-center gap-y-9">
        <div className="w-[48rem] space-y-10 text-center">
          <Image src={"/logoT.svg"} width={200} height={200} />
          <div className="w-full grid grid-cols-2 gap-10">
            <div className="bg-white rounded-2xl grid place-items-center p-8">
              <div className="grid gap-6 place-items-center">
                <Image src={"/icons/hero1.svg"} width={160} height={160} />
                <p className="font-semibold text-2xl">Bank</p>
                <Button onClick={() => handleLogin("admin")}>Connect</Button>
              </div>
            </div>
            <div className="bg-white rounded-2xl grid place-items-center p-8">
              <div className="grid gap-6 place-items-center">
                <div className="h-[160px] grid place-items-center">
                  <Image src={"/icons/hero2.svg"} width={160} height={160} />
                </div>

                <p className="font-semibold text-2xl">Beneficiary-Student</p>
                <Button onClick={() => handleLogin("")}>Connect</Button>
              </div>
            </div>
          </div>
          <p className="text-muted-foreground w-full flex items-center justify-start">
            *This is a POC for showcasing the Education Loan using Aave network.
          </p>
        </div>
      </main>
    </div>
  );
}
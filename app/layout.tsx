import '@/app/ui/global.css';

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html 
    lang="en"
    crxlauncher=""
    >
      <body>{children}</body>
    </html>
  );
}

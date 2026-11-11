CREATE TABLE public.shares (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 slug TEXT UNIQUE NOT NULL,
 title TEXT NOT NULL,
 target_url TEXT NOT NULL,
 created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
 is_active BOOLEAN DEFAULT TRUE,
 created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.shares ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view active links"
ON public.shares
FOR SELECT
TO anon, authenticated
USING (is_active = TRUE);

CREATE POLICY "Admin can view own links"
ON public.shares
FOR SELECT
TO authenticated
USING (auth.uid() = created_by);

CREATE POLICY "Admin can create own links"
ON public.shares
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Admin can update own links"
ON public.shares
FOR UPDATE
TO authenticated
USING (auth.uid() = created_by)
WITH CHECK (auth.uid() = created_by);

GRANT SELECT ON public.shares TO anon, authenticated;
GRANT INSERT, UPDATE ON public.shares TO authenticated;

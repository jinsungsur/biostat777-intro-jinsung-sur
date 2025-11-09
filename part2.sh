#!/usr/bin/env bash
set -euo pipefail

# Usage: bash part2.sh <optional_url_to_students.csv>
URL="${1:-}"

# 1) Get students.csv (prefer curl/wget; fallback to embedded content for reproducibility)
if [[ -n "$URL" ]]; then
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o students.csv "$URL"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO students.csv "$URL"
  else
    echo "Neither curl nor wget found." >&2; exit 1
  fi
elif [[ ! -f students.csv ]]; then
  cat > students.csv <<'CSV'
ID,Name,Age,Gender,Grade,Subject
1,Alice,20,F,88,Math
2,Bob,22,M,76,History
3,Charlie,23,M,90,Math
4,Diana,21,F,85,Science
5,Eve,20,F,92,Math
6,Frank,22,M,72,History
7,Grace,23,F,78,Science
8,Heidi,21,F,88,Math
9,Ivan,20,M,85,Science
10,Judy,22,F,79,History
CSV
fi

echo "== 2) cat students.csv"
cat students.csv
echo

echo "== 3) head (first 5 lines)"
head -n 5 students.csv
echo

echo "== 4) tail (last 3 lines)"
tail -n 3 students.csv
echo

echo "== 5) wc -l (line count)"
wc -l students.csv
echo

echo "== 6) grep for Subject == Math"
grep ',Math$' students.csv
echo

echo "== 7) Female students (Gender == F)"
awk -F, 'NR>1 && $4=="F"{print}' students.csv
echo

echo "== 8) Sort by Age ascending"
{ head -n 1 students.csv && tail -n +2 students.csv | sort -t, -k3,3n; } | column -s, -t
echo

echo "== 9) Unique subjects"
cut -d, -f6 students.csv | tail -n +2 | sort | uniq
echo

echo "== 10) Average grade"
awk -F, 'NR>1 {sum+=$5; n++} END{print sum/n}' students.csv
echo

echo "== 11) Replace 'Math' with 'Mathematics' -> students_mathematics.csv"
sed 's/Math/Mathematics/g' students.csv > students_mathematics.csv
head -n 5 students_mathematics.csv
echo

echo "== 12) Done."

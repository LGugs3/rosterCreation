# for more threads, use `-p <num_threads>`
# use `--solver cp-sat` to use OR Tools
# use `--time-limit <ms>` if its taking too long NOT RECOMMENDED

$fileName = "output.csv"

minizinc config.mpc schedule.mzn -d counter.dzn -o $fileName

"" | Out-File -FilePath $fileName -Encoding ascii -Append

minizinc config.mpc schedule.mzn -d driver.dzn | Out-File -FilePath $fileName -Encoding ascii -Append
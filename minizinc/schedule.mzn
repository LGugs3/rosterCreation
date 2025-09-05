include "preds.mzn";

array[EMPLOYEES, DAYS] of var set of SHIFT: schedule;
array[int] of tuple(EMPLOYEES, DAYS, set of SHIFT): availability;


% at least `min_workers` work every day
constraint forall(d in DAYS)(
    schedule `has_minimum_workers_for` d
);

% sum of total shift for each worker is le max shifts
constraint forall(e in EMPLOYEES)(
    emp_works_maximum(schedule, e, emp_max_shifts[e].max_shifts)
);

% sum of total shifts for each worker is at least min_shifts
constraint forall(e in EMPLOYEES)(
    e `works_minimum_shifts_in` schedule
);

% morn and even shift is covered every day
constraint forall(d in DAYS)(
    schedule `has_shifts_on` d
);

% at least `min_shift_workers` work every shift
constraint forall(d in DAYS)(
    schedule `has_minimum_shift_workers` d
);

% at most `max_shift_workers` work every shift
constraint forall(d in DAYS) (
    schedule `has_maximum_shift_workers` d
);

% restrict schedule to availability
constraint forall(e in EMPLOYEES, d in DAYS)(
    avail_allows_shifts_for(schedule[e, d], availability, e, d)
);


%solve to maximize the number of average shifts per employee

% allows full days
solve maximize average_shifts_per_employee(schedule);

% spreads out shifts more, less full-days
%solve maximize sum([1 | d in DAYS, e in EMPLOYEES where schedule[e, d] != {}]) div card(EMPLOYEES);

% output schedule array as csv format
output ["EMPLOYEE | ", join(" | ", [show(d) | d in DAYS]) ++ "\n"] ++ [
  show(e) ++ " | " ++ join(" | ", [show(schedule[e, d]) | d in DAYS])
  ++ if e < card(EMPLOYEES) then "\n" else "" endif | e in EMPLOYEES
];
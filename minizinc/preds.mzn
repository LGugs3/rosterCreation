enum EMPLOYEES;
enum DAYS = {MON, TUES, WED, THURS, FRI, SAT, SUN};
enum SHIFT = {MORN, EVEN};


par int: num_shifts; % number of shifts in a day
par int: min_workers; % minimum workers per shift * number of shifts
par int: min_shift_workers; % minimum workers per shift
par int: max_shift_workers; % maximum workers per shift
par int: min_shifts; % the minimum shifts each worker can have

type emp_data = par record(par EMPLOYEES: name, par int: max_shifts);
array[EMPLOYEES] of emp_data: emp_max_shifts;

predicate has_minimum_workers_for(array[EMPLOYEES, DAYS] of var set of SHIFT: sched, DAYS: day) =
    sum([card(sched[e, day]) | e in EMPLOYEES]) >= min_workers;

predicate emp_works_maximum(array[EMPLOYEES, DAYS] of var set of SHIFT: sched, EMPLOYEES: emp, int: max_shifts) = 
    sum([card(sched[emp, d]) | d in DAYS]) <= max_shifts;

predicate works_minimum_shifts_in(EMPLOYEES: emp, array[EMPLOYEES, DAYS] of var set of SHIFT: sched) =
    sum([card(sched[emp, d]) | d in DAYS]) >= min_shifts;

predicate has_shifts_on(array[EMPLOYEES, DAYS] of var set of SHIFT: sched, DAYS: day) = 
    {MORN, EVEN} subset array_union([sched[e, day] | e in EMPLOYEES]);

predicate has_minimum_shift_workers(array[EMPLOYEES, DAYS] of var set of SHIFT: sched, DAYS: day) =
    sum([1 | e in EMPLOYEES where MORN in sched[e, day]]) >= min_shift_workers /\
    sum([1 | e in EMPLOYEES where EVEN in sched[e, day]]) >= min_shift_workers;

predicate has_maximum_shift_workers(array[EMPLOYEES, DAYS] of var set of SHIFT: sched, DAYS: day) =
    sum([1 | e in EMPLOYEES where MORN in sched[e, day]]) <= max_shift_workers /\
    sum([1 | e in EMPLOYEES where EVEN in sched[e, day]]) <= max_shift_workers;

predicate avail_allows_shifts_for(var set of SHIFT: shifts, array[int] of tuple(EMPLOYEES, DAYS, set of SHIFT): avail, EMPLOYEES: emp, DAYS: day) = 
    shifts subset array_union([t.3 | t in avail where t.1 = emp /\ t.2 = day]);

function var int: average_shifts_per_employee(array[EMPLOYEES, DAYS] of var set of SHIFT: sched) =
    sum([card(sched[e, d]) | e in EMPLOYEES, d in DAYS]) div card(EMPLOYEES);
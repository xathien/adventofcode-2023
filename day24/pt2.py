import re
import z3

regex = re.compile(r'(\d+),\s*(\d+),\s*(\d+)\s*@\s*(-?\d+),\s*(-?\d+),\s*(-?\d+)')

hailstones = []
lines = open('input', 'r').readlines()
for line in lines:
  x, y, z, vx, vy, vz = map(int, regex.match(line).groups())
  hailstones.append((x, y, z, vx, vy, vz))

I = lambda name: z3.BitVec(name, 64)

solver = z3.Solver()
rx, ry, rz, rvx, rvy, rvz = I('x'), I('y'), I('z'), I('vx'), I('vy'), I('vz')
for i, (x, y, z, vx, vy, vz) in enumerate(hailstones):
  t = I(f't_{i}')
  solver.add(t >= 0)
  solver.add(rx + rvx * t == x + vx * t)
  solver.add(ry + rvy * t == y + vy * t)
  solver.add(rz + rvz * t == z + vz * t)

assert solver.check() == z3.sat
print("Checked!")
model = solver.model()
positions = [model.eval(rx).as_long(), model.eval(ry).as_long(), model.eval(rz).as_long()]
answer = sum(positions)
print("Positions:", positions)
print("Answer:", answer)
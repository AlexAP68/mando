class JoystickDirection {
   double x;
   double y;

  JoystickDirection(this.x, this.y);

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JoystickDirection &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
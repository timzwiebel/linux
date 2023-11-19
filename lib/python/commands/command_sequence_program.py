"""Library for scripts that execute (Bash) shell commands.

See commands_example for an example demonstrating typical usage.
"""

from argparse import ArgumentParser

from commands.base_command_sequence_step import BaseCommandSequenceStep


class CommandSequenceProgram():
  """A sequence of steps that each run (Bash) shell commands."""

  def __init__(self, description: str, steps: list[BaseCommandSequenceStep]):
    """
    Args:
      description: the description of the sequence of commands
      steps: a sequence of BaseCommandSequenceSteps
    """
    self._arg_parser = ArgumentParser(description=description)
    self._arg_parser.add_argument(
        '--continue',
        help=(
            'continue from the specified step'
            ' (default: start at the beginning)'),
        dest='continue_step',
        metavar='STEP')
    self._arg_parser.add_argument(
        '--num-steps',
        type=int,
        help=(
            'specify the number of steps to perform'
            ' (default: perform all steps)'))
    self._arg_parser.add_argument(
        '--dry-run',
        action='store_true',
        help='only print commands, don\'t actually execute them')
    # Ensure that each has a unique step_id. Then call _add_args.
    step_ids = set()
    for step in steps:
      if step.step_id is not None:
        if step.step_id in step_ids:
          raise ValueError(f'Duplicate step found: {step.step_id}')
        step_ids.add(step.step_id)
      step._add_args(self._arg_parser)
    self._steps = steps
    self._args = self._arg_parser.parse_args()
    if self._args.num_steps is not None and self._args.num_steps < 1:
      raise ValueError('NUM_STEPS must be greater than or equal to 1')

  def run(self) -> None:
    """Runs the CommandSequenceProgram."""
    print(
        'All commands are run with bash using these bash options:'
        f' {BaseCommandSequenceStep._BASH_OPTIONS_STRING}')
    start_step = self._args.continue_step
    steps_run = 0
    for step in self._steps:
      if start_step is not None:
        if start_step == step.step_id:
          start_step = None
        else:
          continue
      step.run(self._args)
      steps_run += 1
      if self._args.num_steps is not None and steps_run >= self._args.num_steps:
        break
    if start_step is not None:
      raise ValueError(f'No step with step id "{start_step}"')
    print('\nDone.')

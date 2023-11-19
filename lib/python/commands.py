"""Library for scripts that execute (Bash) shell commands.

See commands_example for an example demonstrating typical usage.
"""

import argparse
import subprocess
import sys
from abc import ABC, abstractmethod
from argparse import ArgumentParser


class BaseCommandSequenceStep(ABC):
  """The base class for a step in a CommandSequenceProgram.

  Attributes:
    step_id: an ID to uniquely identify the step, or None if an ID wasn't
        specified
  """

  _BASH_OPTIONS = [
    'nounset',
    'noclobber',
    'pipefail',
    'errexit',
  ]
  _BASH_OPTIONS_STRING = ' '.join(_BASH_OPTIONS)
  _BASH_OPTIONS_FLAGS = ' '.join([f'-o {opt}' for opt in _BASH_OPTIONS])

  def __init__(self, step_id: str=None, step_description: str=None):
    """
    Args:
      step_id: an ID to uniquely identify the step, allowing the user to
          continue from this step
      step_description: a brief description of the step
    """
    self.step_id = step_id
    self._step_description_short = None
    step_description_parts = []
    if step_id:
      self._step_description_short = f'Step {step_id}'
      step_description_parts.append(self._step_description_short)
    if step_description:
      step_description_parts.append(step_description)
    self._step_description_full = ': '.join(step_description_parts)

  def _add_args(self, argument_parser: ArgumentParser) -> None:
    """Adds arguments to the CommandSequenceProgram.

    Subclasses can implement this method to add extra arguments to the
    CommandSequenceProgram.

    Args:
      argument_parser: the ArgumentParser from the CommandSequenceProgram
    """
    pass

  @abstractmethod
  def _run(self, args: argparse.Namespace) -> None:
    """The implementation of the step.

    Subclasses must implement this method.

    Ideally, the only logic in subclass implementations of this method should be
    sequential calls to self._run_command. Other logic may be implemented in
    Python, however the following must still be true:
    - any logic implemented in Python must respect args.dry_run (i.e., it should
      have no side effects)
    - any logic implemented in Python must print out details that explain the
      logic
    In other words, the user should be able to run with --dry-run (which should
    have no side effects) and infer how to complete the step manually.

    Args:
      args: the command-line arguments
    """
    raise NotImplementedError()

  def run(self, args: argparse.Namespace) -> None:
    """Runs the step.

    Args:
      args: the command-line arguments
    """
    if self._step_description_full:
      print(f'\n===== {self._step_description_full} =====')
    if self.step_id:
      print(f'(rerun with --continue="{self.step_id}" to restart at this step)')
    # Temporarily make args available via self._args so that calls to
    # self._run_command from within self._run don't need to pass args as a
    # parameter just so that self._run_command can check if --dry-run is set.
    self._args = args
    self._run(args)
    del self._args
    if self._step_description_full:
      step_description_short = (
          f'{self._step_description_short} '
          if self._step_description_short
          else '')
      print(f'\n===== Finished {step_description_short}=====')

  def _run_command(
      self,
      description: str,
      command: str,
      expected_return_code: int=0) -> None:
    """
    Args:
      description: a description to print before the command
      command: the command to run
      expected_return_code: the expected return code of the command
    """
    print(f'\n{description}:')
    print(f'> {command}')
    if self._args.dry_run:
      print('\n(command skipped due to --dry-run flag)')
      return
    input('Press [Enter] to continue or [Ctrl+C] to abort...')
    print('')  # Empty line
    # The following merges stdout and stderr. The alternative is to have
    # separate threads reading from stdout and stderr (which seems overly
    # complex), or to wait until the subprocess finishes (which isn't ideal for
    # long-running commands).
    has_output = False
    proc = subprocess.Popen(
        [
          '/bin/bash',
          '-c',
          f'set {BaseCommandSequenceStep._BASH_OPTIONS_FLAGS} && {command}',
        ],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd='/',
        text=True)
    for line in iter(proc.stdout.readline, ''):
      has_output = True
      print(line.rstrip('\r\n'), flush=True)
    proc.wait()
    if proc.returncode != expected_return_code:
      raise ValueError(
          f'Command failed with return code {proc.returncode}'
          f' (expected {expected_return_code})')
    if not has_output:
      print('(command succeeded with no output)')


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

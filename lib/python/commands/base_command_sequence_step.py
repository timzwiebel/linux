import subprocess
from abc import ABC, abstractmethod
from argparse import ArgumentParser, Namespace


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
  def _run(self, args: Namespace) -> None:
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

  def run(self, args: Namespace) -> None:
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

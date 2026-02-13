# -*- coding: utf-8 -*-
"""
Custom Alerter Example for ElastAlert 2
Writes alerts to a local file
"""

from elastalert.alerts import Alerter, BasicMatchString
from elastalert.util import elastalert_logger, lookup_es_key


class AwesomeNewAlerter(Alerter):
    """
    Custom alerter that writes alerts to a local file.

    Required options:
        - output_file_path: Path to the file where alerts will be written
    """

    required_options = frozenset(['output_file_path'])

    def __init__(self, rule):
        super(AwesomeNewAlerter, self).__init__(rule)
        self.output_file = self.rule.get('output_file_path')
        elastalert_logger.info(f"AwesomeNewAlerter initialized. Output: {self.output_file}")

    def alert(self, matches):
        """
        Method called when there is a match.

        Args:
            matches: List of dictionaries with match information
        """
        try:
            with open(self.output_file, 'a', encoding='utf-8') as f:
                for match in matches:
                    # Get readable match representation
                    match_string = str(BasicMatchString(self.rule, match))

                    # Get event timestamp
                    timestamp = lookup_es_key(match, self.rule['timestamp_field'])

                    # Write separator
                    f.write('\n' + '='*80 + '\n')
                    f.write(f"ALERT: {self.rule['name']}\n")
                    f.write(f"Timestamp: {timestamp}\n")
                    f.write('-'*80 + '\n')

                    # Write match details
                    f.write(match_string)
                    f.write('\n')

                f.flush()  # Ensure immediate write

            elastalert_logger.info(
                f"Alert sent successfully. Matches: {len(matches)}, "
                f"File: {self.output_file}"
            )

        except IOError as e:
            elastalert_logger.error(
                f"Error writing alert to file {self.output_file}: {e}"
            )
            raise

    def get_info(self):
        """
        Returns information about this alerter.
        This information is saved to Elasticsearch in the writeback_index.

        Returns:
            dict: Alerter information
        """
        return {
            'type': 'AwesomeNewAlerter',
            'output_file': self.output_file
        }

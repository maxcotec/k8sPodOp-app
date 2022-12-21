import argparse
import time


def parse_arguments() -> argparse.Namespace:
    """Parse the arguments provided to the operator job, according to the arguments set specified

    :return: Arguments object with the parsed arguments
    """
    parser = argparse.ArgumentParser(description='My wild app')
    subparsers = parser.add_subparsers(title='subcommands', required=True, dest="subcommand")

    # ingest data
    ingest = subparsers.add_parser('ingest-data', help='ingest data')
    ingest.add_argument('--execution-date', help='Airflow dag execution date')
    ingest.set_defaults(func=ingest_data)

    # load data
    load = subparsers.add_parser('load-data', help='load data')
    load.set_defaults(func=load_data)

    # Parse the args
    return parser.parse_args()


def ingest_data():
    print("Data ingestion started")
    for i in range(0, 100):
        print(f'... ({i}% completed)')
        time.sleep(0.01)
    print("Data ingestion finished")


def load_data():
    print("Data loading started")
    for i in range(0, 100):
        print(f'... ({i}% completed)')
        time.sleep(0.01)
    print("Data loading finished")


if __name__ == "__main__":
    args = parse_arguments()

    # call appropriate function for subcommand
    args.func()

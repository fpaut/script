#! /bin/bash
diff <(find $1 | sort) <(find $2 | sort)
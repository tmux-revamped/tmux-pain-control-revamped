#!/bin/sh

pain_control_revamped_dir=$(cd "$(dirname "$0")" && pwd)
"${pain_control_revamped_dir}/bin/pain-control-revamped" apply
